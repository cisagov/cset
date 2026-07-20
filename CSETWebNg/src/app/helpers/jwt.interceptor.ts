////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { Router } from '@angular/router';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {

  constructor(private router: Router) { }

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    // add authorization header with jwt token if available
    // and the requestor did not provide one
    if (!request.headers.has('authorization') && !request.headers.has('noauth')) {
      const userToken = localStorage.getItem('userToken');

      if (userToken?.length > 1) {
        request = request.clone({
          setHeaders: {
            Authorization: userToken
          }
        });
      }
    }

    return next.handle(request)
      .pipe(
        catchError((error: HttpErrorResponse) => {
          const shouldEject =
            error.status === 500
            || error.status === 401
            || error.error?.ExceptionMessage === 'JWT invalid';

          if (shouldEject) {
            console.error('HTTP authentication/server error. Logging out.');

            const userToken = localStorage.getItem('userToken');
            // Preserve theme preference
            const savedTheme = localStorage.getItem('cset-theme');

            localStorage.clear();

            if (savedTheme) {
              localStorage.setItem('cset-theme', savedTheme);
            }

            this.router.navigate(
              ['/home/login/eject'],
              { queryParams: { token: userToken } }
            );
          }

          // Preserve the failure so callers can report, retry, or recover from
          // an unsuccessful request instead of treating it as a success.
          return throwError(() => error);
        })
      );
  }
}
