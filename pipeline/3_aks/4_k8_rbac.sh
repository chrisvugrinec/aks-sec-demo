kubectl apply -f ./rbac/dev-namespace.yaml
kubectl apply -f ./rbac/role-aks-user.yaml
kubectl apply -f ./rbac/rolebinding-aks-user.yaml
kubectl apply -f ./nginx/common/ns-and-sa.yaml
kubectl apply -f ./nginx/rbac/rbac.yaml
kubectl apply -f ./nginx/common/default-server-secret.yaml
kubectl apply -f ./nginx/common/nginx-config.yaml
kubectl apply -f ./nginx/common/vs-definition.yaml
kubectl apply -f ./nginx/common/vsr-definition.yaml
kubectl apply -f ./nginx/common/ts-definition.yaml
kubectl apply -f ./nginx/deployment/nginx-ingress.yaml
kubectl apply -f ./nginx/service/loadbalancer.yaml
kubectl apply -f ./rbac/role-aks-user-ingress.yaml
kubectl apply -f ./rbac/rolebinding-aks-user-ingress.yaml
