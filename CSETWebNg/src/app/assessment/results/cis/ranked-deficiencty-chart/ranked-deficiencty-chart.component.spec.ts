import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RankedDeficienctyChartComponent } from './ranked-deficiencty-chart.component';

describe('RankedDeficienctyChartComponent', () => {
  let component: RankedDeficienctyChartComponent;
  let fixture: ComponentFixture<RankedDeficienctyChartComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RankedDeficienctyChartComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RankedDeficienctyChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
