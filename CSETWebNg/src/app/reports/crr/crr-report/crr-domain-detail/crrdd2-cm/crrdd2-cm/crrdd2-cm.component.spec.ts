import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Crrdd2CmComponent } from './crrdd2-cm.component';

describe('Crrdd2CmComponent', () => {
  let component: Crrdd2CmComponent;
  let fixture: ComponentFixture<Crrdd2CmComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Crrdd2CmComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Crrdd2CmComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
