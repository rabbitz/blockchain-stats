package utils

import (
	"github.com/go-kratos/kratos/v2/errors"
)

func IsKnownServerError(err *errors.Error) bool {
	return false
}
