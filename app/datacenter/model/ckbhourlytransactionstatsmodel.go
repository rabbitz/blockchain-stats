package model

import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var _ CkbHourlyTransactionStatsModel = (*customCkbHourlyTransactionStatsModel)(nil)

type (
	// CkbHourlyTransactionStatsModel is an interface to be customized, add more methods here,
	// and implement the added methods in customCkbHourlyTransactionStatsModel.
	CkbHourlyTransactionStatsModel interface {
		ckbHourlyTransactionStatsModel
	}

	customCkbHourlyTransactionStatsModel struct {
		*defaultCkbHourlyTransactionStatsModel
	}
)

// NewCkbHourlyTransactionStatsModel returns a model for the database table.
func NewCkbHourlyTransactionStatsModel(conn sqlx.SqlConn, c cache.CacheConf, opts ...cache.Option) CkbHourlyTransactionStatsModel {
	return &customCkbHourlyTransactionStatsModel{
		defaultCkbHourlyTransactionStatsModel: newCkbHourlyTransactionStatsModel(conn, c, opts...),
	}
}
