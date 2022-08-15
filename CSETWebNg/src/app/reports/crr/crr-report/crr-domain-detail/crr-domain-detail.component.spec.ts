import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrDomainDetailComponent } from './crr-domain-detail.component';

describe('CrrDomainDetailComponent', () => {
  let component: CrrDomainDetailComponent;
  let fixture: ComponentFixture<CrrDomainDetailComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrDomainDetailComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrDomainDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
