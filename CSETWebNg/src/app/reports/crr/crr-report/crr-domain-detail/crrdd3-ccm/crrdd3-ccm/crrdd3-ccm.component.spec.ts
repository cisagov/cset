import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd3CcmComponent } from './crrdd3-ccm.component';

describe('Crrdd3CcmComponent', () => {
  let component: Crrdd3CcmComponent;
  let fixture: ComponentFixture<Crrdd3CcmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd3CcmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd3CcmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
