
# from: https://www.ecobici.cdmx.gob.mx/es/informacion-del-servicio/open-data
u_static = "https://www.ecobici.cdmx.gob.mx/sites/default/files/data/usages/"

# loop to download every month data
yrs = 2011:2017
months = formatC(1:12, width = 2, flag = "0")
for(y in yrs) {
  for(m in months) {
    um = paste0(u_static, y, "-", m, ".csv")
    print(um)
    destfile = paste0("Trips/", y, "-", m, ".csv")
    download.file(url = um, destfile = destfile)
  }
}

