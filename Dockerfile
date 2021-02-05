FROM registry.gitlab.com/datadrivendiscovery/images/primitives:ubuntu-bionic-python36-v2020.1.9 as arrayfire-v3.6.2

ADD https://arrayfire.s3.amazonaws.com/3.6.2/ArrayFire-v3.6.2_Linux_x86_64.sh af3.6.2.sh
RUN mkdir -p /opt/arrayfire
RUN bash af3.6.2.sh --skip-license --prefix=/opt/arrayfire

ENV LD_LIBRARY_PATH=/opt/arrayfire/lib64:$LD_LIBRARY_PATH
ENV LD_PRELOAD=/usr/local/lib/libmkl_core.so:/usr/local/lib/libmkl_sequential.so

FROM arrayfire-v3.6.2

# hack: baseline d3m-arrayfire-primitives installed from /mnt so that
#       we can mount the development out/d3m-arrayfire-primitives over
#       it and python references packages from the correct path
ADD af-scikit-learn /mnt/af-scikit-learn
RUN pip3 install -e /mnt/af-scikit-learn
ADD d3m-arrayfire-primitives /mnt/d3m-arrayfire-primitives
RUN pip3 install -e /mnt/d3m-arrayfire-primitives
