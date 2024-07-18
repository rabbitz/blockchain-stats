package main

import (
	"flag"
	"github.com/Magickbase/blockchain-stats/app/datacenter/internal/config"
	internalSentry "github.com/Magickbase/blockchain-stats/app/datacenter/internal/sentry"
	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/logx"
	"github.com/zeromicro/go-zero/rest"
)

var configFile = flag.String("f", "etc/datacenter-api.yaml", "the config file")

func main() {
	flag.Parse()

	var c config.Config
	conf.MustLoad(*configFile, &c, conf.UseEnv())

	server := rest.MustNewServer(c.RestConf)
	defer server.Stop()

	// init sentry
	internalSentry.InitSentry(server, c)

	//ctx := svc.NewServiceContext(c)

	//handler.RegisterHandlers(server, ctx)

	// handle api errors
	//httpx.SetErrorHandler(func(err error) (int, interface{}) {
	//	//e := errors.FromError(err)
	//
	//	// 判断是否是我们自定义的error
	//	if e.GetCode() >= 500 && !utils.IsKnownServerError(e) {
	//		logx.Errorf("internal server error: %v", err)
	//		sentry.CaptureException(err)
	//
	//		return errorx.Data(v1.ErrorUnknown("internal server error"))
	//	}
	//
	//	return errorx.Data(e)
	//
	//})

	logx.Infof("Starting blockchain-stats server at %s:%d...\n", c.Host, c.Port)
	server.Start()

}
