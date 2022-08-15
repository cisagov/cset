import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrNistCsfCatSummaryComponent } from './crr-nist-csf-cat-summary.component';

describe('CrrNistCsfCatSummaryComponent', () => {
  let component: CrrNistCsfCatSummaryComponent;
  let fixture: ComponentFixture<CrrNistCsfCatSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrNistCsfCatSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrNistCsfCatSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
