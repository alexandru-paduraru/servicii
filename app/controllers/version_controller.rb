class VersionController < ApplicationController
    
#cand se face revert la o actiune se salveaza o versionare a obiectului curent ca pre-versiune pentru activitatea de revert, dar actiunile precedente nu o pot vedea, deci se cauta activitatile premergatoare pornind de la activitatea curenta, prin trasmiterea id-ul activitatii, se cauta pre-versiunea referita, se verifica daca exista versiuni anterioare/posterioare care au acelasi user si care iterate schimba acelasi field, dupa se cauta actiunile care au pre-versiuni aceste versiuni si se sterg
    
    def delete_actions_with_previous_versions1(related_pre_versions)
        related_pre_versions_id = related_pre_versions.pluck(:id)
        related_pre_versions_id.each do |version_id|
            PublicActivity::Activity.destroy_all(:pre_version_id => version_id)
        end
    end
    
    
#versiuni ce au in comun cu versiunea pasata ca parametru: acelasi item_type, acelasi item id, acelasi event   
    def related_versions1(pre_version)
        PaperTrail::Version.all.where(:item_type => pre_version.item_type, :item_id => pre_version.item_id, :event => pre_version.event)
    end
    
#pentru revert pe update se cauta versiunile ce au fost declansate de eventuri de update pe acelasi campuri ca cele ale actiunii referite prin revert    
    
    def delete_previous_activity1(activity)
#         activity.destroy 
        pre_version_id = activity.pre_version_id
        activity.destroy
        if pre_version_id
            pre_version = PaperTrail::Version.find_by_id(pre_version_id)
            related_pre_versions = related_versions1(pre_version)
            delete_actions_with_previous_versions1(related_pre_versions)
        end
    end


    def revert
        #delete the previous activity performed by the user
        activity = PublicActivity::Activity.find_by_id(params[:activity_id])
        if activity
            delete_previous_activity1(activity)
        end
        if PaperTrail::Version.find_by_id(params[:id])
            @version = PaperTrail::Version.find_by_id(params[:id])
# if i am updating an invoice that has the previous state set to nil
#             if @version.item_type == "Invoice"
#                 if @version.reify.state == nil
#                     @version.reify.state = "sent"
#                 end
#             end
# return to previous version
            @version.reify.save!
#salveaza pre-versiune a actiunii curente, declansate de update-ul din revert la ultima versiune a obiectului din baza de date
            activity = PublicActivity::Activity.all.last
            activity.pre_version_id = activity.trackable.versions.last.id
            activity.save!
            
        end
        redirect_to :back# , :notice => "Undid #{@version.event}."
    end
        
    def delete_previous_activity(activity, changes)
        pre_version_id = activity.pre_version_id
        activity.destroy
        if pre_version_id
            pre_version = PaperTrail::Version.find_by_id(pre_version_id)
            if pre_version.item_type == "Invoice"
                related_pre_versions = related_versions_invoice(pre_version, changes)
            end
            if pre_version.item_type == "Customer"
                related_pre_versions = related_versions_customer(pre_version, changes)
            end
            if pre_version.item_type == "User"
                related_pre_versions = related_versions_user(pre_version, changes)
            end
            delete_actions_with_previous_versions(related_pre_versions,changes)
        end 
    end
    
    def related_versions_invoice(pre_version, changes) 
        returned_versions = []
            versions = PaperTrail::Version.all.where(:item_type => pre_version.item_type, :item_id => pre_version.item_id, :event => pre_version.event)
            versions.each do |version|
                previous_version = version.reify
                if version.next
                    post_version = version.next.reify
                else
                    post_version = Invoice.find_by_id(version.item_id)
                end
                if changes.include?("state") && previous_version.state != post_version.state
                returned_versions.append(version)
                end
            end
        returned_versions    
    end
    
    def related_versions_customer(pre_version, changes) 
        returned_versions = []
            versions = PaperTrail::Version.all.where(:item_type => pre_version.item_type, :item_id => pre_version.item_id, :event => pre_version.event)
            versions.each do |version|
                previous_version = version.reify
                if version.next
                    post_version = version.next.reify
                else
                    post_version = Invoice.find_by_id(version.item_id)
                end
                
                pre_hash = previous_version.attributes.except('created_at', 'updated_at', 'company_id', 'user_id','sent_to_collector')
                post_hash = post_version.attributes.except('created_at', 'updated_at', 'company_id', 'user_id','sent_to_collector')
                ok = 0
                changes.each do |change|
                    if pre_hash[change] != post_hash[change] 
                        ok = 1
                    end
                end                  
                if ok == 1
                    returned_versions.append(version)
                end
            end
        returned_versions    
    end
    

    
    def related_versions_user(pre_version, changes) 
        returned_versions = []
            versions = PaperTrail::Version.all.where(:item_type => pre_version.item_type, :item_id => pre_version.item_id, :event => pre_version.event)
            versions.each do |version|
                previous_version = version.reify
                if version.next
                    post_version = version.next.reify
                else
                    post_version = User.find_by_id(version.item_id)
                end
                if (changes.include?("first_name") && previous_version.first_name != post_version.first_name) || (changes.include?("last_name") && previous_version.last_name != post_version.last_name) || (changes.include?("email") && previous_version.email != post_version.email) || (changes.include?("job") && (previous_version.salesman != post_version.salesman || previous_version.accountant != post_version.accountant || previous_version.collector != post_version.collector))
                returned_versions.append(version)
                end
            end
        returned_versions    
    end
    
    def delete_actions_with_previous_versions(related_pre_versions, changes)
        related_pre_versions.each do |version|
            PublicActivity::Activity.destroy_all(:pre_version_id => version.id)
        end
    end
    
    def revert_update
        activity = PublicActivity::Activity.find_by_id(params[:activity_id])
        changes = params[:changed_fields]
        if activity
            delete_previous_activity(activity, changes)
        end
        if PaperTrail::Version.find_by_id(params[:id])
            @version = PaperTrail::Version.find_by_id(params[:id])
            @version.reify.save!
    
            activity = PublicActivity::Activity.all.last
            activity.pre_version_id = activity.trackable.versions.last.id
            activity.save! 
        end
        redirect_to :back
    end
    
    def archive_customer
        customer = Customer.find_by_id(params[:id])
        customer.update_attribute(:active, false)
        redirect_to :back
    end
    
    def delete_user
        user = User.find_by_id(params[:id])
        user.destroy
        redirect_to :back
    end
end
