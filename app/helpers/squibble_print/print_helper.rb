module SquibblePrint::PrintHelper
  def print_business_header(principal = nil)
    render partial: 'helpers/squibble_print/print_helper/print_business_header',
           locals: { principal: principal }
  end

  def print_business_sender(resource = nil)
    render partial: 'helpers/squibble_print/print_helper/print_business_sender',
           locals: { resource: resource }
  end

  # Diese Methode retourniert den aktuellen Adressen
  # Tag für die Darstellung innerhalb des Sichtfensters
  # des Couverts.
  #
  # Ist ein @address Objekt definiert, so wird die Adresse
  # für dieses ausgegebenen. Ansonsten wird die Adresse des
  # aktuellen Mandanten ausgegeben.
  #
  # === Optionen
  # *+address+
  #
  def current_address_tag(address = nil)
    if address.nil?
      render partial: 'helpers/squibble_print/print_helper/current_address_tag_for_current_principal'
    else
      render partial: 'helpers/squibble_print/print_helper/current_address_tag_for_address',
             locals: { address: address }
    end
  end

  # Diese Methode retourniert den Header für einen übergebenen Mandanten.
  # Dabei wird der selbe Mandant für Absender und "Empfängeradresse"
  # verwenrde.
  #
  def principal_address_header(principal = current_principal)
    render partial: 'helpers/print_helper/principal_address_header',
           locals: { resource: principal }
  end

  def default_table_classes
    %(table table-stripped table-hover table-condensed )
  end

  # Diese Methode retourniert das "Stand: XX.XX.XX"
  # für die Ausgabe im Print Modul.
  #
  def version_printed_at
    content_tag :p, nil do |tmp|
      "Stand: #{sq_time Time.zone.now}".html_safe
    end
  end
end
