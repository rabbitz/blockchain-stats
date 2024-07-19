package ckb_stats

import (
	"context"

	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/svc"
	"github.com/zeromicro/go-zero/core/logx"
)

type TransactionTrackingLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

// /ckb_transaction_tracking
func NewTransactionTrackingLogic(ctx context.Context, svcCtx *svc.ServiceContext) *TransactionTrackingLogic {
	return &TransactionTrackingLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *TransactionTrackingLogic) TransactionTracking() error {
	// todo: add your logic here and delete this line

	return nil
}
