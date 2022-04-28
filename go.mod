module github.com/aeraki-mesh/lazyxds

go 1.16

replace github.com/spf13/viper => github.com/istio/viper v1.3.3-0.20190515210538-2789fed3109c

// Old version had no license
replace github.com/chzyer/logex => github.com/chzyer/logex v1.1.11-0.20170329064859-445be9e134b2

// Avoid pulling in incompatible libraries
replace github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d

replace github.com/docker/docker => github.com/moby/moby v17.12.0-ce-rc1.0.20200618181300-9dc6525e6118+incompatible

// Client-go does not handle different versions of mergo due to some breaking changes - use the matching version
replace github.com/imdario/mergo => github.com/imdario/mergo v0.3.5

//replace github.com/envoyproxy/go-control-plane => /Users/huabingzhao/workspace/go-control-plane

//replace github.com/aeraki-mesh/meta-protocol-control-plane-api => github.com/aeraki-mesh/meta-protocol-control-plane-api v0.0.0-20220325074604-63adf119a7bc

require (
	github.com/aeraki-mesh/aeraki v0.0.0-20220425031253-cc9d3e8a2308
	github.com/envoyproxy/go-control-plane v0.9.10-0.20210804155723-c55ac1656905
	github.com/fatih/color v1.12.0
	github.com/go-logr/logr v0.4.0
	github.com/gogo/protobuf v1.3.2
	github.com/gosuri/uitable v0.0.4
	github.com/onsi/ginkgo v1.16.4
	github.com/onsi/gomega v1.15.0
	github.com/spf13/cobra v1.2.1
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.8.1
	google.golang.org/grpc v1.40.0
	istio.io/api v0.0.0-20210819145325-4e216752748c
	istio.io/client-go v1.11.0
	k8s.io/api v0.22.0
	k8s.io/apimachinery v0.22.0
	k8s.io/client-go v0.22.0
	k8s.io/component-base v0.22.0
	k8s.io/klog/v2 v2.9.0
	sigs.k8s.io/yaml v1.2.0
)
