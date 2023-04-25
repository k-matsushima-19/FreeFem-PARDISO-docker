# FreeFem-PARDISO-docker
Docker image with FreeFem v4.12 + Intel MKL PARDISO 

## Build
```bash
docker build . -t freefem-pardiso
```

## Run
Example FreeFem code:
```/path/to/dir/test.edp
mesh Th = square(20,20);
savemesh(Th,"square.mesh");
```

You can run this code as
```bash
cd /path/to/dir

docker run -it --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp freefem-pardiso FreeFem++ test.edp
```