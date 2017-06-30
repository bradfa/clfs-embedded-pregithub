CLFS Book Conversion Tools
==========================

After downloading the book source, there are some things that need to be set up 
on your computer if you want to convert the XML source into something easier to 
read (e.g. HTML, TXT, or PDF).

If you want to convert the Docbook XML to HTML, install the following:

* libxml2
* libxslt
* DocBook DTD 
* DocBook XSL Stylesheets 
* HTMLTidy

If you want to convert the Docbook XML to TXT, install the above items, and then
install the following:

* lynx

If you want to convert the Docbook XML to PDF, install the items listed above
(except lynx) and then install the following:

* JDK
* FOP and JAI

On a reasonably recent Debian or Ubuntu, this should suffice:

```
sudo apt install docbook-xml docbook-xsl fop libxml2-utils lynx make xsltproc tidy
```

To actually convert the Docbook XML source into rendered form, which will be
located at ../render by default (override with RENDERDIR=), execute:

* To XHTML: `make`
* To single file XHTML (nochunks): `make nochunks`
* To PDF: `make pdf`
