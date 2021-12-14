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
