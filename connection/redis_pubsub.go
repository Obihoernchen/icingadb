// IcingaDB | (c) 2019 Icinga GmbH | GPLv2+

package connection

import (
	"github.com/go-redis/redis/v7"
)

type PubSubWrapper struct {
	ps   *redis.PubSub
	rdbw *RDBWrapper
}

func (psw *PubSubWrapper) Subscribe(channels ...string) error {
	for {
		if !psw.rdbw.IsConnected() {
			psw.rdbw.WaitForConnection()
			continue
		}

		err := psw.ps.Subscribe(channels...)

		if err != nil {
			if !psw.rdbw.CheckConnection(false) {
				continue
			}
		}

		return err
	}
}

func (psw *PubSubWrapper) ReceiveMessage() (*redis.Message, error) {
	for {
		if !psw.rdbw.IsConnected() {
			psw.rdbw.WaitForConnection()
			continue
		}

		msg, err := psw.ps.ReceiveMessage()

		if err != nil {
			if !psw.rdbw.CheckConnection(false) {
				continue
			}
		}

		return msg, err
	}
}

func (psw *PubSubWrapper) Channel() <-chan *redis.Message {
	return psw.ps.Channel()
}

func (psw *PubSubWrapper) ChannelSize(size int) <-chan *redis.Message {
	return psw.ps.ChannelSize(size)
}

func (psw *PubSubWrapper) Close() error {
	for {
		if !psw.rdbw.IsConnected() {
			psw.rdbw.WaitForConnection()
			continue
		}

		err := psw.ps.Close()

		if err != nil {
			if !psw.rdbw.CheckConnection(false) {
				continue
			}
		}

		return err
	}
}
