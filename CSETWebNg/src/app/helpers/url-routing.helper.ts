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

/**
 * Parses a URL/path string and extracts query parameters.
 * Used for proper handling of returnPath with embedded query params.
 */
export function parseReturnPath(url: string): { path: string; queryParams: { [key: string]: string } | null } {
  if (!url) {
    return { path: '', queryParams: null };
  }

  if (!url.includes('?')) {
    return { path: url, queryParams: null };
  }

  const [path, queryString] = url.split('?');
  const params = queryString.split('&');
  const queryParamsObj: { [key: string]: string } = {};

  params.forEach((param) => {
    const [key, value] = param.split('=');
    if (key) {
      queryParamsObj[key] = value || '';
    }
  });

  return { path, queryParams: queryParamsObj };
}
