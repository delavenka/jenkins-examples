FROM alpine:latest
WORKDIR /app
RUN echo "Selam! Bu imaj Idilsu tarafindan Kaniko ile olusturuldu." > mesaj.txt
RUN echo "Build Tarihi: \$(date)" >> mesaj.txt
RUN echo "Guncelleme denemesi - trigger"
CMD ["cat", "mesaj.txt"]
