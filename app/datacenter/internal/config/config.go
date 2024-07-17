package config

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/redis"
	"github.com/zeromicro/go-zero/rest"
)

type Config struct {
	rest.RestConf

	DatacenterDB struct {
		DataSource string
	}

	Redis      redis.RedisConf
	CacheRedis cache.CacheConf

	SentryConf SentryConf
}
