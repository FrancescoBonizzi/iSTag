namespace IsTag.ViewModels
{
    public class PrintQrViewModel
    {
        public string QrCode { get; }
        public string Name { get; }

        public PrintQrViewModel(string qrCode, string name)
        {
            QrCode = qrCode;
            Name = name;
        }
    }
}
