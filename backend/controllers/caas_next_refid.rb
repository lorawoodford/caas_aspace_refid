class ArchivesSpaceService < Sinatra::Base

  Endpoint.post('/plugins/caas_next_refid')
    .description("Get next ref_id for provided resource")
    .params(["resource_id", Integer, "The resource id", :required => "true"])
    .permissions([])
    .returns([200, "{'resource_id', 'ID', 'next_refid', N}"]) \
  do
    current_refid = CaasAspaceRefid.find(resource_id: params[:resource_id])
    incremented_id = !current_refid.nil? ? current_refid.next_refid + 1 : 1
    if !current_refid.nil?
      new_refid_record = current_refid.update(next_refid: incremented_id)
      json = CaasAspaceRefid.to_jsonmodel(new_refid_record.id)
      handle_update(CaasAspaceRefid, current_refid.id, json)
    else
      CaasAspaceRefid.create_from_json(JSONModel(:caas_next_refid).from_hash({:resource_id => params[:resource_id],
                                                                              :next_refid => incremented_id }))
    end

    json_response(:resource_id => params[:resource_id], :next_refid => incremented_id)
  end

end
