package sentry

import (
	"fmt"
	"log"
	"net/http"
	"runtime/debug"
	"time"

	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/config"
	"github.com/getsentry/sentry-go"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/rest"
	"github.com/zeromicro/go-zero/rest/httpx"
)

func InitSentry(server *rest.Server, c config.Config) {
	err := sentry.Init(sentry.ClientOptions{
		Dsn:              c.SentryConf.Dsn,
		TracesSampleRate: 0.6,
		ServerName:       "blockchain-stats",
		Environment:      c.Mode,
	})

	if err != nil {
		log.Fatalf("sentry.Init: %s", err)
	}

	server.Use(func(next http.HandlerFunc) http.HandlerFunc {
		return func(w http.ResponseWriter, r *http.Request) {
			defer func() {
				if result := recover(); result != nil {
					logx.Errorf("recover inner panic:%v\n", result)
					sentry.CurrentHub().Recover(result)
					sentry.Flush(time.Second * 10)

					value := fmt.Sprintf("%v\n%s", err, debug.Stack())
					formatValue := fmt.Sprintf("(%s - %s) %s", r.RequestURI, httpx.GetRemoteAddr(r), fmt.Sprint(value))
					logx.WithContext(r.Context()).Error(formatValue)
					w.WriteHeader(http.StatusInternalServerError)
				}
			}()

			next.ServeHTTP(w, r)
		}
	})
}
