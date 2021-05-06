IMAGE=localhost:5000/syslog-agent

build:
	docker build -t $(IMAGE) .

push: .k3d-registry
	docker push $(IMAGE)

k8s: push .k3d
	kubectl apply -f k8s -f test

k3d-up k3d cluster cluster-up: .k3d

.k3d: .k3d-cluster .k3d-metrics

.k3d-cluster: .k3d-registry
	k3d cluster create syslog -p "8081:80@loadbalancer" --registry-use local
	touch $@

.k3d-registry:
	k3d registry create local -p 5000
	touch $@


metrics: .k3d-metrics

.k3d-metrics: .helm-setup
	helm install -n kube-system metrics prometheus-community/kube-state-metrics
	touch $@

.k3d-prometheus:
	helm install -n kube-system prometheus prometheus-community/kube-prometheus-stack
	touch $@ .k3d-metrics

helm: .helm-setup

.helm-setup:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	touch $@


k3d-down cluster-down:
	k3d cluster delete syslog
	k3d registry delete local
	rm -f .k3d-*