library(rvest)
library(httr)

urls <- paste0("https://hemerotecadigital.bne.es/hd/es/results?parent=9e9bd249-8568-4142-baf7-ffa47a5a4500&t=alt-asc&s=", c(0,10,20,30))

links <- c()

for (i in urls) {
  html <- read_html_live(i)
  links_i <- html |> html_elements("article div > ul > li:nth-child(2) a") |> 
    html_attr("href")
  links <- append(links, links_i)
}

links_pdfs <- gsub("\\n", "", paste0("https://hemerotecadigital.bne.es", links))


dir.create("pdfs_la_internacional")

for (d in links_pdfs[1:10]) {
  r <- GET(d, config = config(ssl_verifypeer = 0))
  writeBin(content(r, "raw"), 
           paste0("./pdfs_la_internacional/", gsub("^pdf.+=", "", basename(d))))
}
