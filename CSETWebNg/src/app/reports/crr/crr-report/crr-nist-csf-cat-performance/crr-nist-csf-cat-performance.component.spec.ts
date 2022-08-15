import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrNistCsfCatPerformanceComponent } from './crr-nist-csf-cat-performance.component';

describe('CrrNistCsfCatPerformanceComponent', () => {
  let component: CrrNistCsfCatPerformanceComponent;
  let fixture: ComponentFixture<CrrNistCsfCatPerformanceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrNistCsfCatPerformanceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrNistCsfCatPerformanceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
