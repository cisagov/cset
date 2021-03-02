import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EdmBluebarChartComponent } from './edm-bluebar-chart.component';

describe('EdmBluebarChartComponent', () => {
  let component: EdmBluebarChartComponent;
  let fixture: ComponentFixture<EdmBluebarChartComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EdmBluebarChartComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EdmBluebarChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
