import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HydroBarChartComponent } from './hydro-bar-chart.component';

describe('HydroBarChartComponent', () => {
  let component: HydroBarChartComponent;
  let fixture: ComponentFixture<HydroBarChartComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HydroBarChartComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(HydroBarChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
