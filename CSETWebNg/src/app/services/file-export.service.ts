////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';


/**
 * Service repsonsible for getting a blob from the API and saving it to the user's file system.
 */
@Injectable({
  providedIn: 'root'
})
export class FileExportService {

  /**
   * 
   */
  constructor(
    private http: HttpClient
  ) { }

  /**
   * Calls an API endpoint and saves the blob response as a file.
   */
  fetchAndSaveFile(url: string, token: string = null) {
    if (!token) {
      token = localStorage.getItem('userToken');
    }

    this.getBlobFromApi(url, token).subscribe((response: HttpResponse<Blob>) => {
      this.saveBlobAsFile(response);
    },
      error => console.error('Error downloading the file', error)
    );
  }

  /**
   * Calls an API endpoint and returns an Observable with the blob response.
   */
  getBlobFromApi(url: string, token: string): Observable<HttpResponse<Blob>> {
    const headers = new HttpHeaders().set('Authorization', `Bearer ${token}`);
    return this.http.get(url, { headers, observe: 'response', responseType: 'blob' });
  }

  /**
   * Saves the blob as a file. 
   */
  saveBlobAsFile(response: HttpResponse<Blob>) {
    const blob = response.body;
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;

    const contentDisposition = response.headers.get('Content-Disposition');
    const filename = this.getFilenameFromContentDisposition(contentDisposition);

    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  /**
   * Parses the filename from the Content-Disposition header contents.
   * If it can't find a filename, the file is named "downloaded_file" with no extension.
   */
  private getFilenameFromContentDisposition(contentDisposition: string | null): string {
    if (!contentDisposition) {
      return 'downloaded_file';
    }
    const matches = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.exec(contentDisposition);
    return (matches != null && matches[1]) ? matches[1].replace(/['"]/g, '') : 'downloaded_file';
  }
}
