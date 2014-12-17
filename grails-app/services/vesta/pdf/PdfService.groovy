package vesta.pdf

import org.xhtmlrenderer.pdf.ITextRenderer

/**
 * Servicio para hacer PDFs
 */
class PdfService {

    boolean transactional = false

/*  A Simple fetcher to turn a specific URL into a PDF.  */
    /**
     * Transforma un URL a PDF
     * @param url
     * @param pathFonts
     * @return
     */
    byte[] buildPdf(url, String pathFonts) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ITextRenderer renderer = new ITextRenderer();

/*
        ITextFontResolver fontResolver = renderer.getFontResolver();
        fontResolver.addFontDirectory(pathFonts, true);

//        println pathFonts + "arial.ttf"

        fontResolver.addFont(pathFonts + "arial.ttf", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "arialbd.ttf", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "arialbi.ttf", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ariali.ttf", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ARIALN.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ARIALNB.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ARIALNBI.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ARIALNI.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ARIALUNI.TTF", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
        fontResolver.addFont(pathFonts + "ariblk.ttf", BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
*/

//        println "123123123 " + url
        try {
            renderer.setDocument(url);
            renderer.layout();
            renderer.createPDF(baos);
            byte[] b = baos.toByteArray();
            return b
        }
        catch (Throwable e) {
            e.printStackTrace()
            log.error e
        }
    }

/*  
  A Simple fetcher to turn a well formated XHTML string into a PDF
  The baseUri is included to allow for relative URL's in the XHTML string
*/

    /**
     * Transforma una cadena XHTML a PDF
     * @param content
     * @param baseUri
     * @return
     */
    byte[] buildPdfFromString(content, baseUri) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ITextRenderer renderer = new ITextRenderer();
//        ITextFontResolver fontResolver = renderer.getFontResolver();
//        fontResolver.addFont("", true);
        println "ASDFASDFASDFASDF " + baseUri
        try {
            renderer.setDocumentFromString(content, baseUri);
            renderer.layout();
            renderer.createPDF(baos);
            byte[] b = baos.toByteArray();
            return b
        }
        catch (Throwable e) {
            log.error e
        }
    }

}

