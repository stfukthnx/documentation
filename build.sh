docker build -t kerberos-documentation .
docker tag kerberos-documentation gcr.io/kerberosio-1214/kerberos-documentation:4.0
docker push gcr.io/kerberosio-1214/kerberos-documentation:4.0