package ckb_stats

import (
	"net/http"

	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/logic/ckb_stats"
	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/svc"
	"github.com/zeromicro/go-zero/rest/httpx"
)

// /ckb_transaction_tracking
func TransactionTrackingHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		l := ckb_stats.NewTransactionTrackingLogic(r.Context(), svcCtx)
		err := l.TransactionTracking()
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.Ok(w)
		}
	}
}
