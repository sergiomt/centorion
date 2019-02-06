# Proxy Configuration

If you are using a proxy with basic authentication (not NTLM), you will have to configure it for Bundler and Vagrant.
	* From your host command line do
```
SET HTTP_PROXY=http://_XXX.XXX.XXX.XXX_:_port_
SET HTTPS_PROXY=ttp://_XXX.XXX.XXX.XXX_:_port_
SET HTTP_PROXY_USER=_proxyuser_
SET HTTPS_PROXY_USER=_proxyuser_
SET HTTP_PROXY_PASS=_userpasswd_
SET HTTPS_PROXY_PASS=_userpasswd_
```
		on a Windows host, or

```
export HTTP_PROXY=http://_XXX.XXX.XXX.XXX_:_port_
export HTTPS_PROXY=ttp://_XXX.XXX.XXX.XXX_:_port_
export HTTP_PROXY_USER=_proxyuser_
export HTTPS_PROXY_USER=_proxyuser_
export HTTP_PROXY_PASS=_userpasswd_
export HTTPS_PROXY_PASS=_userpasswd_
```
		on a Linux host.
	* From the command line `vagrant plugin install vagrant-proxyconf-1.5.2.gem`
	* Last edit Vagrantfile and change config.proxy.http, config.proxy.https and config.proxy.no_proxy values to the right IP and port and user/password.
