////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
export class X1 {

    goal = '';
    barChart = '';
    greenPct = 0;
    yellowPct = 0;
    redPct = 0;

    template1 = `<tr>
        <td>${this.goal}</td>
        <td style="width: 50%; padding: .25rem; vertical-align: middle;">
            ${this.barChart}
        </td>
    </tr>`;

    templateBarChart = `<div class="edm-horizontal-bar-chart">
        <div class="edm-hzbc-bar">
            <div class="edm-hzbc-green green-score" style="flex-basis: ${this.greenPct}%;">1</div>
            <div class="edm-hzbc-yellow yellow-score" style="flex-basis: ${this.yellowPct}%;">1</div>
            <div class="edm-hzbc-red red-score" style="flex-basis: ${this.redPct}%;">5</div>
        </div>
    </div>`;

    /**
     * 
     */
    render(json: string) {

    }

}
