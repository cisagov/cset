//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CryptoBuffer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DataLayerCore.Model;
using CSETWeb_Api.Helpers;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class ProtectedFeatureController : ApiController
    {
        [HttpGet]
        [Route("api/EnableProtectedFeature/Features/")]
        public List<EnabledModule> getFeatures()
        {   
            using (CSET_Context context = new CSET_Context())
            {
                return (from a in context.SETS.Where(x => x.IsEncryptedModule == true && x.IsEncryptedModuleOpen == true)
                            select new EnabledModule() { Short_Name =  a.Short_Name, Full_Name= a.Full_Name }).ToList();
            }
        }

        [HttpPost]  
        [Route("api/EnableProtectedFeature/unlockFeature/")]
        public string unlockFeature([FromBody]String unlock)
        {
            try
            {
                using (CSET_Context context = new CSET_Context())
                {

                    ColumnSetEncryption columnencryptor = new ColumnSetEncryption(unlock, "451f0b54b51f");
                    var list = context.NEW_QUESTION.Where(x => x.Original_Set_Name == "FAA");

        
                     //* This fi.simple_questions check is looking to see if the question is encrypted or not
                     //* encrypted questions are base64 encoded where a space is not a valid character 
                     //* so if we find a space then the question is not encrypted if we do not find a space 
                     //* then the question must be in base64 encoding and therefor is encrypted
                     
                    var fi = list.FirstOrDefault();
                    if (fi == null)
                        return "";

                    if (fi.Simple_Question.Contains(" "))
                    {
                        AddNewlyEnabledModule(context);
                        return "This module is already enabled";
                    }


                    foreach (NEW_QUESTION q in list)
                    {
                        if (!q.Simple_Question.Contains(" "))
                            q.Simple_Question = columnencryptor.Decrypt(q.Simple_Question);
                    }
                    var rlist = context.NEW_REQUIREMENT.Where(x => x.Original_Set_Name == "FAA").OrderBy(x => x.Requirement_Id);
                    foreach (NEW_REQUIREMENT r in rlist)
                    {
                        if (!r.Requirement_Text.Contains(" "))
                            r.Requirement_Text = columnencryptor.Decrypt(r.Requirement_Text);
                        if (!r.Supplemental_Info.Contains(" "))
                            r.Supplemental_Info = columnencryptor.Decrypt(r.Supplemental_Info);
                    }
                    AddNewlyEnabledModule(context);
                    context.SaveChanges();

                    return "FAA PED Questionnaire has been enabled.";
                }
            }
            catch (Exception)
            {   
                return "Sorry that unlock code was not recognized check the code and try again";
            }
        
        }

        private void AddNewlyEnabledModule(CSET_Context context)
        {
            var sets2 = context.SETS.Where(x => x.Set_Name == "FAA");
            foreach (SETS sts in sets2)
            {
                sts.IsEncryptedModuleOpen = true;                
            }
            context.SaveChanges();
        }
    }
    public class EnabledModule
    {
        public String Short_Name { get; set; }
        public String Full_Name { get; set; }
    }
}


