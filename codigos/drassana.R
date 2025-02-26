require(rvest)

urls <- paste0("https://revistadrassana.cat/index.php/Drassana/issue/archive/", 1:2)

urls

links <- c()

for (i in urls) {
  html <- read_html(i)
  links_i <- html |> html_elements("a.title") |> html_attr("href")
  links <- append(links, links_i)
}

links_pdf <- c()

for (l in links) {
  html <- read_html(l)
  links_pdf_l <- html |> html_elements("a.galley-link[data-type='pdf']") |> html_attr("href")
  links_pdf <- append(links_pdf, links_pdf_l)
  links_pdf <- unique(links_pdf)
}

links_pdf_download <- gsub("view", "download", links_pdf)

dir.create("pdfs_drassana")

for (d in links_pdf_download[1:10]) {
  download.file(url=d, destfile=paste0("./pdfs_drassana/", basename(dirname(d)), "_", basename(d), ".pdf"))
}
