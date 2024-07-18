package svc

import (
	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/config"
	"github.com/zeromicro/go-zero/core/stores/redis"
)

type ServiceContext struct {
	Config      config.Config
	RedisClient *redis.Redis
}

func NewServiceContext(c config.Config) *ServiceContext {
	redisClient := c.Redis.NewRedis()

	return &ServiceContext{
		Config:      c,
		RedisClient: redisClient,
	}
}
