IMAGE=localhost:5000/syslog-agent
DEFAULT_METRICS=kube-state-metrics
LOCAL_PORT=8081

build:
	docker build -t $(IMAGE) .

push: .k3d-registry
	docker push $(IMAGE)

test: up k8s ready
	bash test/test.sh

k8s deploy: push .k3d
	kubectl apply -f k8s -f test

k3d-up k3d cluster cluster-up up: .k3d

k3d-down cluster-down down:
	k3d cluster delete syslog
	k3d registry delete local
	rm -f .k3d-*

ready:
	@while kubectl get pods -A | grep -q ContainerCreating; do sleep 2; done || true

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


metrics: .k3d-$(DEFAULT_METRICS)

.k3d-kube-state-metrics: .helm-setup
	helm install -n kube-system metrics prometheus-community/kube-state-metrics
	touch $@

.k3d-prometheus:
	helm install -n kube-system prometheus prometheus-community/kube-prometheus-stack
	touch $@ .k3d-kube-state-metrics

helm: .helm-setup

.helm-setup:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	touch $@


