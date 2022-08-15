import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrMil1PerformanceSummaryComponent } from './crr-mil1-performance-summary.component';

describe('CrrMil1PerformanceSummaryComponent', () => {
  let component: CrrMil1PerformanceSummaryComponent;
  let fixture: ComponentFixture<CrrMil1PerformanceSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrMil1PerformanceSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrMil1PerformanceSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
