// tag::copyright[]
/*******************************************************************************
 * Copyright (c) 2017, 2022 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *******************************************************************************/
// end::copyright[]
package io.openliberty.sample.system;

import jakarta.ws.rs.core.Response;

import jakarta.enterprise.context.RequestScoped;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

import org.eclipse.microprofile.metrics.annotation.Counted;
import org.eclipse.microprofile.metrics.annotation.Timed;

import org.json.JSONException;
import org.json.JSONObject;

import io.openliberty.sample.system.MyHttpClient;

@RequestScoped
@Path("/httpcall")
public class ExternalHttpCall {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Timed(name = "getPropertiesTime",
           description = "Time needed to get the JVM system properties")
    @Counted(absolute = true, description
             = "Number of times the JVM system properties are requested")
    public Response doExternalHttpCall() {
        MyHttpClient theMyHttpClient = new MyHttpClient();
//        String myJSON ="{\"URL\":\"http://test.de\"}";  
        JSONObject jsonObject = new JSONObject();
        String result = null;
		try
		{
			jsonObject.put("Url", "https://httpbin.org/get");
			System.out.println("JSON Object: "+jsonObject);

            result = theMyHttpClient.doGet("https://httpbin.org/get");
		}
		catch (Exception e)
		{
			System.out.println("Error "+e.toString());
		} 
        return Response.ok(result).build();
    }

}
