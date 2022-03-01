module jw4.us/nsc

go 1.13

require (
	github.com/caddyserver/caddy v1.0.4
	github.com/coredns/coredns v1.6.6
	github.com/coredns/federation v0.0.0-20190827145442-019e06919f0c
	jw4.us/nspub v0.0.6
)

replace (
	github.com/Azure/go-autorest => github.com/Azure/go-autorest v13.0.0+incompatible
	golang.org/x/net v0.0.0-20190813000000-74dc4d7220e7 => golang.org/x/net v0.0.0-20190827160401-ba9fcec4b297
)
