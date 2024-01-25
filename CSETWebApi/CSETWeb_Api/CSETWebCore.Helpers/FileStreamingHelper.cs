//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Net.Http.Headers;
using System;
using System.Globalization;
using System.IO;
using System.Text;
using System.Threading.Tasks;


namespace CSETWebCore.Helpers
{
	public static class FileStreamingHelper
	{
		private static readonly FormOptions _defaultFormOptions = new FormOptions();

		public static async Task<FormValueProvider> StreamFile(this HttpRequest request, Stream targetStream)
		{
			if (!MultipartRequestHelper.IsMultipartContentType(request.ContentType))
			{
				throw new Exception($"Expected a multipart request, but got {request.ContentType}");
			}

			// Used to accumulate all the form url encoded key value pairs in the request.
			var formAccumulator = new KeyValueAccumulator();

			var boundary = MultipartRequestHelper.GetBoundary(
				MediaTypeHeaderValue.Parse(request.ContentType),
				_defaultFormOptions.MultipartBoundaryLengthLimit);
			var reader = new MultipartReader(boundary, request.Body);

			var section = await reader.ReadNextSectionAsync();
			while (section != null)
			{
				ContentDispositionHeaderValue contentDisposition;
				var hasContentDispositionHeader = ContentDispositionHeaderValue.TryParse(section.ContentDisposition, out contentDisposition);

				if (hasContentDispositionHeader)
				{
					if (MultipartRequestHelper.HasFileContentDisposition(contentDisposition))
					{
						await section.Body.CopyToAsync(targetStream);
					}
					else if (MultipartRequestHelper.HasFormDataContentDisposition(contentDisposition))
					{
						// Content-Disposition: form-data; name="key"
						//
						// value

						// Do not limit the key name length here because the 
						// multipart headers length limit is already in effect.
						var key = HeaderUtilities.RemoveQuotes(contentDisposition.Name);
						var encoding = GetEncoding(section);
						using (var streamReader = new StreamReader(
							section.Body,
							encoding,
							detectEncodingFromByteOrderMarks: true,
							bufferSize: 1024,
							leaveOpen: true))
						{
							// The value length limit is enforced by MultipartBodyLengthLimit
							var value = await streamReader.ReadToEndAsync();
							if (String.Equals(value, "undefined", StringComparison.OrdinalIgnoreCase))
							{
								value = String.Empty;
							}
							formAccumulator.Append(key.Value, value); // For .NET Core <2.0 remove ".Value" from key

							if (formAccumulator.ValueCount > _defaultFormOptions.ValueCountLimit)
							{
								throw new InvalidDataException($"Form key count limit {_defaultFormOptions.ValueCountLimit} exceeded.");
							}
						}
					}
				}

				// Drains any remaining section body that has not been consumed and
				// reads the headers for the next section.
				section = await reader.ReadNextSectionAsync();
			}

			// Bind form data to a model
			var formValueProvider = new FormValueProvider(
				BindingSource.Form,
				new FormCollection(formAccumulator.GetResults()),
				CultureInfo.CurrentCulture);

			return formValueProvider;
		}

		private static Encoding GetEncoding(MultipartSection section)
		{
			MediaTypeHeaderValue mediaType;
			var hasMediaTypeHeader = MediaTypeHeaderValue.TryParse(section.ContentType, out mediaType);
			// UTF-7 is insecure and should not be honored. UTF-8 will succeed in 
			// most cases.
#pragma warning disable SYSLIB0001 // Type or member is obsolete
			if (!hasMediaTypeHeader || Encoding.UTF7.Equals(mediaType.Encoding))
#pragma warning restore SYSLIB0001 // Type or member is obsolete
			{
				return Encoding.UTF8;
			}
			return mediaType.Encoding;
		}
	}
}
