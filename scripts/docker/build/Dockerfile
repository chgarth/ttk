FROM ubuntu:hirsute
LABEL maintainer="Christoph Garth <garth@cs.uni-kl.de>"

ENV  DEBIAN_FRONTEND=noninteractive
COPY helper.sh /root/

# install OSMesa
COPY mesa.sh /root/
RUN  /root/helper.sh /root/mesa.sh

# install ISPC
COPY ispc.sh /root/
RUN /root/helper.sh /root/ispc.sh

# install Embree
COPY embree.sh /root
RUN  /root/helper.sh /root/embree.sh

COPY oidn.sh /root
RUN  /root/helper.sh /root/oidn.sh

COPY rkcommon.sh /root
RUN  /root/helper.sh /root/rkcommon.sh

COPY openvkl.sh /root
RUN  /root/helper.sh /root/openvkl.sh

# install OSPRay
COPY ospray.sh /root/
RUN  /root/helper.sh /root/ospray.sh

# install ZFP
COPY zfp.sh /root
RUN  /root/helper.sh /root/zfp.sh

# install Spectra
COPY spectra.sh /root
RUN  /root/helper.sh /root/spectra.sh

# install Jupyter
# COPY jupyter.sh /root/
# RUN  /root/helper.sh /root/jupyter.sh
# EXPOSE 8888

# install ParaView
ARG paraview=5.8.1
ENV PARAVIEW_VERSION=${paraview}

COPY paraview.sh /root/
RUN  /root/helper.sh /root/paraview.sh
ENV  PYTHONPATH=/usr/lib/python3.8/site-packages

# run pvserver by default
CMD /usr/bin/pvserver
EXPOSE 11111

# install TTK
ARG ttk=dev 
ENV TTK_VERSION=${ttk}

ARG devcontainer
ENV DEVCONTAINER=${devcontainer}

COPY ttk.sh /root/
RUN  /root/helper.sh /root/ttk.sh
