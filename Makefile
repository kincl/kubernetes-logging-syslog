IMAGE=localhost:5000/syslog-agent
DEFAULT_METRICS=kube-state-metrics
LOCAL_PORT=8081

## make build -- build the image
build: .k3d-image

.k3d-image: Dockerfile start.sh rsyslog.conf.template
	docker build -t $(IMAGE) .
	@touch $@

## make push -- push the image to the local k3d registry
push: .k3d-registry .k3d-image
	docker push $(IMAGE)

## make test -- install all components and run a simple test by cURLing the NGINX container and looking for the access record
test: build up k8s ready
	bash test/test.sh

## run a Snyk scan on the image
scan:
	docker scan $(IMAGE)

## make k8s or make deploy -- install the components into the cluster
k8s deploy: push .k3d
	kubectl apply -f k8s -f test

## make up -- create and configure the testing cluster
k3d-up k3d cluster cluster-up up: .k3d

## make down -- delete the testing cluster
k3d-down cluster-down down:
	k3d cluster delete syslog
	k3d registry delete local
	rm -f .k3d-*

## make ready -- wait for all components to be ready
ready:
	@echo -n "Waiting for pod count..."
	@while [ "$$(kubectl get pods -A | wc -l)" -lt 4 ] ; do sleep 2; echo -n .; done || true
	@echo "DONE"
	@echo -n "Waiting for pods ready..."
	@while kubectl get pods -A | grep -q -E 'Pending|ContainerCreating'; do sleep 2; echo -n . ; done || true
	@echo "READY"

.k3d: .k3d-cluster .k3d-kube-state-metrics

.k3d-cluster: .k3d-registry
	k3d cluster create syslog -p "$(LOCAL_PORT):80@loadbalancer" --registry-use local
#	@echo "Waiting for cluster to initialize"
#	@while [ -n "kubectl get -n kube-system pods | grep ContainerCreating" ]; do echo -n "."; sleep 3; done
#	@echo DONE
	touch $@

.k3d-registry:
	k3d registry create local -p 5000
	touch $@


# Install the selected metrics server package
metrics: .k3d-$(DEFAULT_METRICS)

.k3d-kube-state-metrics: .helm-setup
	helm install -n kube-system metrics prometheus-community/kube-state-metrics
	touch $@

.k3d-prometheus:
	helm install -n kube-system prometheus prometheus-community/kube-prometheus-stack
	touch $@ .k3d-kube-state-metrics

# Run a local helm setup
helm: .helm-setup

.helm-setup:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	touch $@

clean:
	-make -f $(lastword $(MAKEFILE_LIST)) down >/dev/null 2>/dev/null
	rm -f .helm-setup

real-clean: clean
	docker image rm $(IMAGE)

help:
	awk '/^##/{print}' $(lastword $(MAKEFILE_LIST))
