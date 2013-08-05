class InvoicetemplateController < ApplicationController
layout "invoicetemplate"

   
   	def invoice_template
       	invoice_id = params[:invoice_id]
       	@invoice = Invoice.find_by_id(invoice_id)
       	@customer = @invoice.customer
       	@company = @invoice.company
       	@user = User.find_by_id(@invoice.user_id)	
        @services = Invoice.index_services(@invoice)
       	
	render 'invoice_template'
	end
	
	def invoice_pdf
        invoice_id = params[:invoice_id]
       	@invoice = Invoice.find_by_id(invoice_id)
       	@customer = @invoice.customer
       	@company = @invoice.company
       	@user = User.find_by_id(@invoice.user_id)	
        @services = Invoice.index_services(@invoice)
        respond_to do |format|
            html = render_to_string(:layout => false , :action => "invoice_template_pdf.html.erb")
            kit = PDFKit.new(html.html_safe, :page_size => 'Letter', :orientation => 'Portrait')
            kit.stylesheets << 'app/assets/stylesheets/invoice_reset.css' 
            kit.stylesheets << 'app/assets/stylesheets/invoice_style.css'
            kit.stylesheets << 'app/assets/stylesheets/invoice_bootstrap.css'

            
    	   	format.html {send_data(kit.to_pdf, :filename => "invoice#{@invoice.number}.pdf", :type => 'application/pdf')}
        end
        return
    end
    
    def invoice_xml
        invoice_id = params[:invoice_id]
        @invoice = Invoice.find_by_id(invoice_id)
        respond_to do |format|
            format.xml {send_data(:xml => @invoice.to_xml(:except => [:created_at, :updated_at])) }
        end
    end
    
    def invoice_csv
        invoice_id = params[:invoice_id]
        @invoice = Invoice.find_by_id(invoice_id)
        @customer = @invoice.customer
        respond_to do |format|
            format.csv {send_data(Invoice.to_csv(@customer,@invoice))}
        end
    end

end
