import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CrrContactInformationComponent } from './crr-contact-information.component';

describe('CrrContactInformationComponent', () => {
  let component: CrrContactInformationComponent;
  let fixture: ComponentFixture<CrrContactInformationComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CrrContactInformationComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CrrContactInformationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
