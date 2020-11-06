# kube-client

Have all kubernetes client tools as a neat package.

## Example kubeconfig using oidc

In `~/.kube/config`:
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: 
      ...... BASE64 encoded cert of your kube cluster
    server: ... URL of your kube cluster ....
  name: mycluster
contexts:
- context:
    cluster: mycluster
    user: oidc
  name: oidc@mycluster
current-context: oidc@mycluster
kind: Config
preferences: {}
users:
- name: oidc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url= .... OIDC Provider discover url ...
      - --oidc-client-id= .... OIDC client id ...
      - --oidc-client-secret=... OIDC client secret ...
      - --listen-address=:18000
      command: kubectl
      env: null
```

Basic command:
```
docker run --rm -ti -p 18000:18000  -v ~/.kube:/home/.kube -u $(id -u):$(id -g) -v $(pwd):/project untoldwind/kube-client kubectl get pods
```
(Since this is running in a container you have to manually open http://localhost:18000 in your browser to perform the oidc login)
