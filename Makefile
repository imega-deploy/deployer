TAG=latest

release: build
	@docker login --username $(DOCKER_USER) --password $(DOCKER_PASS)
	@docker push imegadeploy/deployer:$(TAG)

build:
	@docker build -t imegadeploy/deployer:$(TAG) .

test:
	@mkdir -p $(CURDIR)/log
	@docker run --rm -v $(CURDIR):/data -w /data -e TOKEN=/data/imega-deploy.deployer.token -e WEBHOOK= -e TEST_NGINX_ERROR_LOG=/data/log/error_log.log imega/openresty-prove:0.0.1 -r -v t/

clean:
	@rm -rf $(CURDIR)/log
