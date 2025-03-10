import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';
import { AssessmentService } from './assessment.service';

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
   * 
   */
  private getFilenameFromContentDisposition(contentDisposition: string | null): string {
    if (!contentDisposition) {
      return 'downloaded_file';
    }
    const matches = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.exec(contentDisposition);
    return (matches != null && matches[1]) ? matches[1].replace(/['"]/g, '') : 'downloaded_file';
  }
}
