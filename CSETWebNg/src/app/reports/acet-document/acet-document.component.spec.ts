import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetDocumentComponent } from './acet-document.component';

describe('AcetDocumentComponent', () => {
  let component: AcetDocumentComponent;
  let fixture: ComponentFixture<AcetDocumentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AcetDocumentComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetDocumentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
