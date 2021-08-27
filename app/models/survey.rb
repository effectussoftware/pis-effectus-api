class Survey < ActiveRecord::Base
  validates :title, presence: true
  

  has_many :questions, -> class_name: '::Question', dependent: :destroy

  validate :end_time_must_be_greater_than_start_time
  validate :end_time_and_start_time_must_be_greater_than_now
  validate :presence_of_start_date_end_date

  def end_time_must_be_greater_than_start_time
    return unless check_presence_of_start_date_end_date && check_end_time_and_start_time

    errors.add(:start_time, 'La fecha de fin debe ser más grande que la fecha de inicio')
  end

  def end_time_and_start_time_must_be_greater_than_now
    return unless check_presence_of_start_date_end_date && start_time_end_time_greater_than_now 

    errors.add(:start_time, 'Las fechas de fin e inicio deben estar en el futuro')
  end

  def start_time_end_time_greater_than_now
    (start_time < Time.zone.now || end_time < Time.zone.now)
  end

  def check_end_time_and_start_time
    start_time >= end_time
  end

  def check_presence_of_start_date_end_date
    (!start_time.present? && !end_time.present?) || (start_time.present? && end_time.present?)  
  end

  def presence_of_start_date_end_date
    return unless check_presence_of_start_date_end_date
      errors.add(:start_time, 'Debe existir fecha de comienzo y fecha de fin')
  end



end